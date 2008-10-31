Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYJaPPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYJaPPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYJaPPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:15:03 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:33578 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYJaPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:15:01 -0400
Message-ID: <490B20C4.40006@csr.com>
Date: Fri, 31 Oct 2008 15:14:12 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: uwb: struct device - replace bus_id with dev_name(), dev_set_name()
References: <1225393576.21973.36.camel@nga.site>
In-Reply-To: <1225393576.21973.36.camel@nga.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2008 15:14:12.0667 (UTC) FILETIME=[54C780B0:01C93B6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".

Applied, thanks.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
