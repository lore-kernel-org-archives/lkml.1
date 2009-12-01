Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZLAFtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZLAFtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 00:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZLAFtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 00:49:13 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:56390 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZLAFtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 00:49:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AY0CSOEZOGDTCaSYq1e4a/sanT33A45tdqcO5HmtwLZGqrhlOMIykJ5MMaHuY/G0hS
         4u2jYlLyo1CyGmsToCoSgoRN8vayysl6aaf3YSbCCroJNfnMsONXz/oDLZeUORKlsvPp
         NfXshM4iP4ZhbdcS1dKrSldt6MNseoYPkzfig=
MIME-Version: 1.0
In-Reply-To: <1259590999.12870.0.camel@gandalf.stny.rr.com>
References: <d1f76ba30911300038w272578dfx9adb116bde493e00@mail.gmail.com> 
	<d1f76ba30911300150g10c1382clb2958245ebf94362@mail.gmail.com> 
	<1259590999.12870.0.camel@gandalf.stny.rr.com>
From: Yogesh Chaudhari <mr.yogesh@gmail.com>
Date: Tue, 1 Dec 2009 11:18:58 +0530
Message-ID: <d1f76ba30911302148t2bfceed0w79515dccc31b0bc3@mail.gmail.com>
Subject: Re: Ethernet issues with lite5200 board from linux-2.6.31
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/30 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 2009-11-30 at 15:20 +0530, Yogesh Chaudhari wrote:
>> Hello,
>>          I am running linux kernel with rt patch on embedded board
>> based on lite5200 eval board. From linux-2.6.31 release, in which the
>> mdio patch has gone inside,  the fec ethernet does not come up on this
>> board. I get the following message at startup:
>> mpc52xx MII bus: probed
>
> Do you see the same issue without adding the rt patch?
This issue is present even without the rt patch.
>
> -- Steve
>
>
>



-- 
DREAM IT, CODE IT

"CODITO, ERGO SUM"
"I CODE, THEREFORE I AM"
