Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYAOSLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYAOSLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYAOSLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:11:32 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:43364 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYAOSLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:11:32 -0500
Message-ID: <478CF710.10701@s5r6.in-berlin.de>
Date: Tue, 15 Jan 2008 19:10:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: gregkh@suse.de, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ieee1394 : use class iteration api
References: <20080112095008.GB2893@darkstar.te-china.tietoenator.com> <a8e1da0801150038p242c8717k9db373b1beb2404d@mail.gmail.com>
In-Reply-To: <a8e1da0801150038p242c8717k9db373b1beb2404d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> Is it right for me to put_device after class_find_device at following point?

Yes, that's right.
-- 
Stefan Richter
-=====-==--- ---= -====
http://arcgraph.de/sr/
