Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbXKYOCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbXKYOCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 09:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXKYOCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 09:02:23 -0500
Received: from mail.syneticon.net ([213.239.212.131]:44215 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbXKYOCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 09:02:23 -0500
Message-ID: <47498065.5070203@wpkg.org>
Date: Sun, 25 Nov 2007 15:02:13 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

(...)

>> * After each major kernel release bugzilla should send a kind request for
>>   retesting to all open bugs.
> 
> Good idea, IMO.

Another alternative would be to send such a request if a given bug had 
no activity for, say, 6 months.

(...)

>> * Last but not least our bugzilla just looks ugly (it is _very_ important,
>>   I feel disgusted each time I have to work with it, OTOH I love using
>>   gitweb - you get the idea).
> 
> Well, that doesn't matter to me as long as it's useful.  Any ideas how to
> improve that? ;-)

Upgrade to Bugzilla 3.0.x. Its interface looks a bit better (and has a 
handful of useful features).

(...)

>> Hmm, what about switching to some proprietary bug tracking system just to
>> talk Linus into writing a superior one?  ;-)
> 
> I think that we just have to get an idea of what exactly is needed.  IOW, we
> need to know exactly how we're going to handle bugs as much as we needed
> to know exactly how we were going the handle the flow of changes.
> Perhaps it would be necessary to use a proprietary bug tracking system for some
> time for this purpose, but _maybe_ we can figure it out without anything like
> that.

How do others track bugs for software projects? RedHat, Novell, IBM, 
others - anyone reading this thread?


-- 
Tomasz Chmielewski
http://wpkg.org

