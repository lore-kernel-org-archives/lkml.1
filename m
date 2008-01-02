Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbYABOsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbYABOsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 09:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbYABOsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 09:48:15 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:60744 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYABOsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 09:48:09 -0500
Date: Wed, 2 Jan 2008 15:48:08 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080102144807.GA809@boogie.lpds.sztaki.hu>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 04:07:04PM +0800, Dave Young wrote:

> Please try the -mm tree kernel, might have been fixed by :
> http://lkml.org/lkml/2007/11/18/141

I've applied the patch on top of 2.6.24-rc6 (I don't want to run -mm
kernels on this machine). We'll see what happens.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
