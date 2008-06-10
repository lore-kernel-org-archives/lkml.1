Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbYFJAD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbYFJAD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 20:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYFJADu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 20:03:50 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:38056 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbYFJADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 20:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AgTA3G6+gbVc/p6An4zSt1zPJzu9m3thpjPmV1+N9x7lFSt+/4g0UvcWF3fC0ONi56
         g9ORqiF4r0q2RQXVvmm3Wvtfu+yXuvAERoEEIN7OtXaks6apFAeRCH5DqBnMU6VJenXw
         pvzfAs4xUSIi/8zD4u8Eprrj21H9LgFAHsG74=
Message-ID: <dd18b0c30806091703s1e21d204m3991f6c51b578450@mail.gmail.com>
Date: Tue, 10 Jun 2008 00:03:47 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Jiri Kosina" <jkosina@suse.cz>, "Greg KH" <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806100040.34377.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dd18b0c30806091504u43e0e901jb786e57f5cbf47cd@mail.gmail.com>
	 <dd18b0c30806091536s724ba33cmfdd9ccb49b0cbd53@mail.gmail.com>
	 <200806100040.34377.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 10:40 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Dienstag 10 Juni 2008 00:36:02 schrieb Justin Mattock:
>
>> O.K. This is smaller than last weeks? anyways I applied the patch, and
>
> That patch also saved some power, this just fixes bugs. It's indeed smaller.
>
>> am not seeing appletouch freak out like it did, also
>> two finger scroll is still active upon wakeup(FWIW).  Cool, and thanks
>
> Dmitry, Greg,
>
> we have confirmation. Would you take the patch for 2.6.26 and stable?
>
>        Regards
>                Oliver
>

Please ignore the two finger scroll part(even though it seems to
work), I have been ignoring my xorg.conf for sometime and need to
configure it so I can have all functionality back, and then I'll let
you know what the status is.
regards;

-- 
Justin P. Mattock
