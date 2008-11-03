Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYKCJFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYKCJFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYKCJEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:04:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:23465 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbYKCJEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=biZ1yEJfPbBrz2SVUt96yf5XgS9DxcI2p0dXskJJ2+W6mFwzcwQRHXAv4dmMEInoNX
         VPFHzgHVn8rHzL/s86MyGK+K5hdOzzcwCDlOUDu3a/CUvpjt+LSx6On61uXy3cWfjsh5
         N7sfJMex9Z4bqIH2WVhCyRXPetQCN0vrOBXSA=
Message-ID: <1ba2fa240811030104w3ebc3acfs2e1a135457a1bade@mail.gmail.com>
Date: Mon, 3 Nov 2008 11:04:29 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11845] Suspend regression on Lenovo x60
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <200811030055.22645.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
	 <wOAXuecskPD.A.3LH.0keDJB@chimera>
	 <20081102220758.GA14374@localhost.aei.mpg.de>
	 <200811030055.22645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 1:55 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 2 of November 2008, Carlos R. Mafra wrote:
>> On Sun  2.Nov'08 at 17:07:01 +0100, Rafael J. Wysocki wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.27.  Please verify if it still should be listed and let me know
>> > (either way).
>> >
>> >
>> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=11845
>> > Subject             : Suspend regression on Lenovo x60
>> > Submitter   : Jens Axboe <jens.axboe@oracle.com>
>> > Date                : 2008-10-24 18:02 (10 days old)
>> > References  : http://marc.info/?l=linux-next&m=122487159829507&w=4
>> >               http://marc.info/?l=linux-kernel&m=122512449714310&w=4
>> > Handled-By  : Rafael J. Wysocki <rjw@sisk.pl>
>> >               Tomas Winkler <tomasw@gmail.com>
>> > Patch               : http://marc.info/?l=linux-kernel&m=122513311900482&w=4
>> >               http://marc.info/?l=linux-wireless&m=122518625308673&w=4
>>
>> It is fixed by commit 10d0bd56966571d0324dfd9bbb8aa913a60bef5f which
>> is now in Linus' tree.
>
> Thanks, closed.

Is this queued  also for 2.6.27 stable ? My email was bounced back
I've used linux-stable@veger.kernel.org
Thanks
Tomas
