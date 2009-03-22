Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbZCVVhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbZCVVhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 17:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZCVVhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 17:37:18 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:44262 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbZCVVhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 17:37:17 -0400
Message-ID: <49C6AF8B.6080602@emcraft.com>
Date: Mon, 23 Mar 2009 00:37:15 +0300
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <49C5486D.9020103@emcraft.com>	 <e9c3a7c20903211500j3f1575e7o2ad9fb5969a2bdd@mail.gmail.com>	 <49C56D74.3030303@emcraft.com> <e9c3a7c20903211553w5200ea0cu360d0a57fef77c66@mail.gmail.com>
In-Reply-To: <e9c3a7c20903211553w5200ea0cu360d0a57fef77c66@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Dan Williams wrote:
>> Unfortunately we are not getting paid for this project any more so I
>> can't spend much time on it.
>>     
>
> Hopefully I can occasionally call on you to try out some tests with
> ppc440spe driver and hardware?  As we have seen in the past that
> platform hits corner cases that iop13xx does not.
>   

Well, I think I'll be able to run some tests... but I can't do much
coding or debugging here or my manager won't be happy...

Regards, Ilya.

