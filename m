Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYKYGvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYKYGvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 01:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYKYGv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 01:51:27 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:25674 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYKYGv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 01:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZnJ0s+fqrd7e25Ag3cw1p8xZhNZ0QAu/n8NDiGS96nsWHZZ2Ba1QolnnU1iqXA16i7
         ExWexsqGL781LqY7qnsB6KBpvSv/B8E6OvD3vvZtK6kjIXo1pyObSrEhZ+DAnC724mkg
         X6Dl0+A4+/6LtLb6uGWw4fa4i9jGc744tQMUg=
Message-ID: <5d5443650811242251g5ddda028q9413b0ff47fc08a8@mail.gmail.com>
Date: Tue, 25 Nov 2008 12:21:25 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: v4l2_device/v4l2_subdev: please review
Cc: v4l <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200811242309.37489.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811242309.37489.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tue, Nov 25, 2008 at 3:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi all,
>
> I've finally tracked down the last oops so I could make a new tree with
> all the latest changes.
>

Please send these patches to mailing list (git-send-email?) for easy
review. Also CCing LKML for wider view is also good, as we are doing
some core changes right?

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
