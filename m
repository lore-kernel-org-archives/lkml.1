Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbXFOQYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbXFOQYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbXFOQXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:23:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:8521 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbXFOQXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:23:52 -0400
Date: Fri, 15 Jun 2007 18:23:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Avi Kivity <avi@argo.co.il>
cc: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <467273AB.9010202@argo.co.il>
Message-ID: <Pine.LNX.4.64.0706151823360.32724@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15 2007 14:10, Avi Kivity wrote:
>
>Some things are not achievable with block-level raid.  For example, with
>redundancy integrated into the filesystem, you can have three copies for
>metadata, two copies for small files, and parity blocks for large files,
>effectively using different raid levels for different types of data on
>the same filesystem.

Sounds like you want RAIF, not RAID.



	Jan
-- 
