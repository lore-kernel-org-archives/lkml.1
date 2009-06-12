Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbZFLEyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbZFLEyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZFLEyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:54:32 -0400
Received: from 6532244hfc110.tampabay.res.rr.com ([65.32.244.110]:49012 "EHLO
	blue.3gfp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbZFLEyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:54:31 -0400
X-Greylist: delayed 1696 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 00:54:31 EDT
Message-ID: <4A31D8E8.4090200@3gfp.com>
Date: Fri, 12 Jun 2009 00:26:16 -0400
From: Harvey Chapman <hchapman-linux-kernel@3gfp.com>
User-Agent: Postbox 1.0b12 (Macintosh/2009051120)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Matching hard disks to BIOS boot order
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a way to figure out which hard disks match the BIOS boot order?

I'm trying to tell a Linux program which disk to use based on the disk 
numbers (0,1,...) used by Windows. The best solution I've found so far 
is disk serial number, but that hasn't been terribly reliable for other 
reasons.

Thanks, H.
