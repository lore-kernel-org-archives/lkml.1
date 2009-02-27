Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbZB0D5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbZB0D5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZB0D5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:57:16 -0500
Received: from mail.anarazel.de ([217.115.131.40]:52440 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbZB0D5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:57:15 -0500
Message-ID: <49A7648D.2080705@anarazel.de>
Date: Fri, 27 Feb 2009 04:57:01 +0100
From: Andres Freund <andres@anarazel.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20081210 Shredder/3.0b1
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Alex Buell <alex.buell@munted.org.uk>,
       adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jonathan Bastien-Filiatrault <joe@x2a.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4 ENOSPC Bug
References: <20090216162028.3032666a@lithium.local.net> <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de> <20090216190001.GB11788@mini-me.lan> <499AF598.7080400@anarazel.de> <499C7B41.1090800@anarazel.de> <20090218212957.GR3600@mini-me.lan>
In-Reply-To: <20090218212957.GR3600@mini-me.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2009 10:29 PM, Theodore Tso wrote:
>> [10379.575904] ext4: find_group_flex failed, fallback succeeded dir 416319
>> [10379.576002] ext4: find_group_flex failed, fallback succeeded dir 416319
>> [10379.579981] ext4: find_group_flex failed, fallback succeeded dir 416319
>> [10379.580097] ext4: find_group_flex failed, fallback succeeded dir 416319
>> (with different directories)
> Can you send me a dumpe2fs of the filesystem in question?  I'm curious
> what was going on...
Unfortunately the system was rebooted, before I had the chance to do the 
dump - since then the problem has not reemerged.
Would a dump after reboot still be usefull?

Andres
