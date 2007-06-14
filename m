Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbXFNRVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbXFNRVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXFNRVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:21:05 -0400
Received: from mail.syneticon.net ([213.239.212.131]:46765 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbXFNRVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:21:04 -0400
Message-ID: <467178B9.5070302@wpkg.org>
Date: Thu, 14 Jun 2007 19:19:53 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
References: <466D379C.6000809@wpkg.org> <20070614163803.GA31984@lazybastard.org>
In-Reply-To: <20070614163803.GA31984@lazybastard.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel schrieb:
> On Mon, 11 June 2007 13:53:00 +0200, Tomasz Chmielewski wrote:
>> jffs2 only works on mtd devices, and that excludes pendrives, which are 
>> block devices. I know LogFS will work with block devices one day, but 
>> currently, it doesn't (and is not in the kernel yet as well).
> 
> Actually, LogFS does work on block devices now.  Performance on hard
> disks is quite bad.  Hopefully that becomes untrue just as fast as your
> slightly outdated claim. :)

Cool, does it mean we have the first Linux filesystem supporting 
compression, which can be used on USB-sticks (I don't count old 
ext2+compression patches)? :)


-- 
Tomasz Chmielewski
http://wpkg.org


