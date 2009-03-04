Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZCDVjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZCDVjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 16:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZCDVjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 16:39:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42644 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZCDVjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 16:39:31 -0500
To: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Yinghai Lu <yinghai@kernel.org>, Sarah Sharp <sarah.a.sharp@intel.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090303235354.GA7145@gamba.jf.intel.com>
	<86802c440903031731x36c1180dk72a3631bb4397319@mail.gmail.com>
	<49ADDB0B.1050002@oracle.com> <20090304175727.GC29823@elte.hu>
	<20090304212503.GA9611@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Mar 2009 13:39:21 -0800
In-Reply-To: <20090304212503.GA9611@suse.de> (Greg KH's message of "Wed\, 4 Mar 2009 13\:25\:03 -0800")
Message-ID: <m1bpshx912.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, sarah.a.sharp@intel.com, yinghai@kernel.org, randy.dunlap@oracle.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: EHCI debug documentation
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> Yinghai Lu wrote:
>> > b. netchip USB debug cable
>> 
>> http://www.plxtech.com/products/NET2000/NET20DC/default.asp
>
> I have reports that the newer version of this device does not work on
> Linux as it isn't enumeratable as a "real" usb device on one end.
>
> I don't have one of these new devices yet to test it out, has anyone
> else heard of this problem?

With the first generation of devices I remember they were peculiar and
finicky.  I don't recall the exact details but I remember the devices
able to get into weird states that may resemble what you describe.

Eric
