Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXIOSVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXIOSVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXIOSVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:21:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:3256 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbXIOSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:21:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=msk7Zc2e2xOO0QxMGLQVjpOH1rIZJwipcsBv0iiN2Ahve4Cvkn9aOZs4i8U6Wt1DTM2hpfHROHQjkfHcFqpCoskRsQyDRZf9rq9NvW7OM5qTDNxAVw3BC63fPSKpqg6a08Quj5HaES2TqdeP4aVt4pKDVHLak947MiwbFnlFJSg=
From: Matej Laitl <strohel@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another options and comments
Date: Sat, 15 Sep 2007 20:20:58 +0200
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200709152004.11930.strohel@gmail.com>
In-Reply-To: <200709152004.11930.strohel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200709152021.00069.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 of September 2007 20:04:10 Matej Laitl wrote:
> menuconfig currently represents options implied by another option ('select'
> directive in Kconfig) by prefixing them with '---'. Unfortunately the same
> notation is used for comments.
>
> (...)

Oh please reply to my address strohel@gmail.com. I mismatched Reply-To and 
In-Reply-To e-mail headers when trying to stick the message to original 
thread.

Sorry for the noise and inconvenience I caused.
