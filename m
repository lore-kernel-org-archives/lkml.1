Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbXAXXYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbXAXXYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 18:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932884AbXAXXYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 18:24:18 -0500
Received: from 125.14.124.24.cm.sunflower.com ([24.124.14.125]:30236 "EHLO
	mail.atipa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932883AbXAXXYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 18:24:17 -0500
Message-ID: <45B7EAA0.5020106@atipa.com>
Date: Wed, 24 Jan 2007 17:24:16 -0600
From: Roger Heflin <rheflin@atipa.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net
Subject: Re: Nvidia MCP55 Machine reboots on ixgb driver load
References: <45B7CA3D.9020601@atipa.com> <45B7E06C.8000901@wolfmountaingroup.com>
In-Reply-To: <45B7E06C.8000901@wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jan 2007 23:25:51.0984 (UTC) FILETIME=[FCE38F00:01C7400E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff V. Merkey wrote:
> 
> I have seen something similiar with the ixgb.   make certain there are 
> **NO** other adapters sharing the PCI bus with the
> ixgb.   There are some serious hardware compatibility issues with the 
> ixgb mixing it with other cards on the same PCI-X bus,
> and I have seen power loading problems, performance slowdowns, reboots, 
> and other issues when an ixgb is installed in a
> system.

It is on its own pci-x bus with no other cards on the
pci slots that are on the same bus, the machine in question has
4 slots divided into 2 buses.

                         Roger

