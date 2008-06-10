Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYFJBLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYFJBLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 21:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbYFJBL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 21:11:29 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:44694 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbYFJBL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 21:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=feNCN3bStgasO7pptNQI4dOZkOKuqMvSi3aE1j/MGdpjO/blVVkJ2WNZSzMDmEss39
         JMyTw62mPN0VHWpwGJu7HgARj47dJPIzp2t6Hzpi8zjgxPgwFh5vpS/brJKs52zCzJCW
         KbhAg5nmVt/NhRZNwENf+5xm6yFEgTSE3rcjY=
Message-ID: <dd18b0c30806091811h241db314w5b95e08ca77b77d5@mail.gmail.com>
Date: Tue, 10 Jun 2008 01:11:27 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Oliver Neukum" <oliver@neukum.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Greg KH" <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0806100205340.10085@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dd18b0c30806091504u43e0e901jb786e57f5cbf47cd@mail.gmail.com>
	 <dd18b0c30806091536s724ba33cmfdd9ccb49b0cbd53@mail.gmail.com>
	 <200806100040.34377.oliver@neukum.org>
	 <dd18b0c30806091703s1e21d204m3991f6c51b578450@mail.gmail.com>
	 <Pine.LNX.4.64.0806100205340.10085@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 12:06 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 10 Jun 2008, Justin Mattock wrote:
>
>> Please ignore the two finger scroll part(even though it seems to work),
>> I have been ignoring my xorg.conf for sometime and need to configure it
>> so I can have all functionality back, and then I'll let you know what
>> the status is. regards;
>
> You can easily test with 'evtest' utility to see the data that are really
> comming out of a kernel for your particular device, to filter out any
> mangling that X does on these events.
>
> --
> Jiri Kosina
> SUSE Labs
>

Cool; Thanks for the help.

-- 
Justin P. Mattock
