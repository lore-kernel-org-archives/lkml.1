Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZIANb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZIANb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZIANb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:31:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:45077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbZIANb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:31:27 -0400
Message-ID: <4A9D2204.1000608@kernel.org>
Date: Tue, 01 Sep 2009 22:30:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Andrei Tanas <andrei@tanas.ca>, Mark Lord <mlord@pobox.com>,
       Ric Wheeler <rwheeler@redhat.com>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: MD/RAID time out writing superblock
References: <004e01ca25e4$c11a54e0$434efea0$@ca> <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name> <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca> <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca> <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BC033.9000909@pobox.com> <4A9C60A1.50303@rtr.ca> <640f6103c45b6cba6f84f887bde227e4@localhost> <4A9D1E7D.1050104@rtr.ca>
In-Reply-To: <4A9D1E7D.1050104@rtr.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 01 Sep 2009 13:30:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mark Lord wrote:
>> Mine errored out again with exactly the same symptoms, this time after
>> only
>> few days and with the "tunable" set to 2 sec. I got a warranty
>> replacement
>> but haven't shipped this one yet. Let me know if you want it.
> ..
> 
> Not me.  But perhaps Tejun ?

I think you're much more qualified than me on the subject. :-)

Anyone else?  Ric, are you interested with playing the drive?

-- 
tejun
