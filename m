Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266Ab0AJXQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0AJXQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185Ab0AJXQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:16:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:30042 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab0AJXQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:16:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fFNHxg30c3jDZdHP/ZubSrLvm9dRrzIZBQLvB5NI2hl7OlbLibaYf9D59pxDApJGj7
         ReRVXkn46fRcPiR/wwooMRuTMIQULVTFJLeGmJrn8/Dnbi4mIZiQugahhmDrQRtR2g/0
         30mBOmggwuCXl9gzMHIFi7ZOQ/PNxspWYFdG0=
MIME-Version: 1.0
In-Reply-To: <20100110224914.GB5039@nowhere>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
	 <omZ8aBZReyD.A.vd.qNlSLB@chimera> <20100110224914.GB5039@nowhere>
Date: Mon, 11 Jan 2010 02:16:10 +0300
Message-ID: <a4423d671001101516l13a709fhe5c07343926160d1@mail.gmail.com>
Subject: Re: [Bug #14899] reiserfs: inconsistent lock state
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/11 Frederic Weisbecker <fweisbec@gmail.com>:
> On Sun, Jan 10, 2010 at 11:32:53PM +0100, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.32.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=14899
>> Subject               : reiserfs: inconsistent lock state
>> Submitter     : Alexander Beregalov <a.beregalov@gmail.com>
>> Date          : 2009-12-11 22:06 (31 days old)
>> References    : http://marc.info/?l=linux-kernel&m=126056920702515&w=4
>> Handled-By    : Frederic Weisbecker <fweisbec@gmail.com>
>> Patch         : http://patchwork.kernel.org/patch/67256/
>>                 http://patchwork.kernel.org/patch/67257/
>
>
>
> The fix have been pulled upstream. Would be nice to have Alexander
> confirmation that it's really fixed though.

Yes, all warnings have disappeared. Thanks a lot.
