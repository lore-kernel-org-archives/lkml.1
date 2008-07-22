Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYGVSVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYGVSVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYGVSVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:21:31 -0400
Received: from 81-66-111-23.rev.numericable.fr ([81.66.111.23]:55681 "EHLO
	rubis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYGVSVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:21:30 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 14:21:30 EDT
Message-ID: <4886235F.6010407@jourdois.fr>
Date: Tue, 22 Jul 2008 20:13:51 +0200
From: =?UTF-8?B?U3TDqXBoYW5lIEpvdXJkb2lz?= <stephane@jourdois.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: Enable packet injection for
 iwl4965
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com> <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com> <4885DDC4.2060609@googlemail.com>
In-Reply-To: <4885DDC4.2060609@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DSPAM-Factors: 27,
	linux, 0.00010,
	wrote, 0.00010,
	git, 0.00010,
	git, 0.00010,
	>+>, 0.00010,
	To*linux, 0.00011,
	To*linux, 0.00011,
	To*vger.kernel.org, 0.00012,
	>>, 0.00013,
	>>, 0.00013,
	Subject*[PATCH], 0.00016,
	currently, 0.00016,
	References*mail.gmail.com>, 0.00017,
	References*mail.gmail.com>, 0.00017,
	User-Agent*Thunderbird, 0.00017,
	since, 0.00018,
	next, 0.00021,
	To*kernel, 0.00022,
	The+patch, 0.00022,
	testing, 0.00023,
	patch, 0.00025,
	any, 0.00025,
	any, 0.00025,
	tree, 0.00028,
	least, 0.00029,
	of+this, 0.00029,
	To*linux+kernel, 0.00031
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Engel a écrit :
> Stefanik Gábor wrote:
>> What is the status of this patch? Did it get lost? Was it rejected? I
>> didn't get any answer on it, and I can't see it in iwlwifi-2.6.git or
>> wireless-testing.git.
> 
> Actually it is at least in linux-next since 30th of June as of commit 
> 914233d68f07d5d9c22630cd5a84fdfd98f39da2.

I beg your pardon, but this commit is for iwl3945, not iwl4965.
The patch for iwl4965 is currently not in any git tree.

Stephane.

-- 
  ///  Stephane Jourdois     /"\  ASCII RIBBON CAMPAIGN \\\
(((    Consultant securite  \ /    AGAINST HTML MAIL    )))
  \\\   157 Bd Davout         X                         ///
   \\\  75020  Paris         / \    +33 6 8643 3085    ///
