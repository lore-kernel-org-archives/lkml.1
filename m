Return-Path: <linux-kernel-owner+w=401wt.eu-S964873AbXDWH3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873AbXDWH3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965663AbXDWH3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:29:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:54911 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964873AbXDWH3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TvvDwFRS8gow8Br+AwzCL9oyEv4KWYeb2MA+shNW3ypA3ytpp4WsZS8S3XRj7jvBnbFCh65jf9TWxUiAUMgNeId40kfvEwcyuUUe9EN98XgeH7lDJX4pBPXcQGZnHlAh3LSIlXpiS+FTdFEIWJjDPBBRGYARqXycqjMJZEgiklQ=
Message-ID: <5a04609e0704230029x56f08654v9d9d3fb1fef414ee@mail.gmail.com>
Date: Mon, 23 Apr 2007 10:29:25 +0300
From: "Sergey Yanovich" <ynvich@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
Cc: "Alex Dubov" <oakad@yahoo.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070423070401.GA26428@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4627D402.8020107@gmail.com>
	 <20070422013411.45105.qmail@web36709.mail.mud.yahoo.com>
	 <5a04609e0704220515h4049afas4dc98b90e66d1d16@mail.gmail.com>
	 <20070423070401.GA26428@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > For a typical, non-linux-geek user there are just two states of the device -
> > available and not available. Ububtu is famous for its end-user support.
> > They ship your driver since linux-2.6.17. But they pack it in one module.
> > And that is _much_ easier, then a hotplug script.
>
> No, we ship a udev script.

OK, me bad for using the present tense. But you had a single module
in Oct 2006, didn't you? And maybe, you would like to post the script.

--
Sergey Yanovich
