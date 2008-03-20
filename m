Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYCTELI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYCTELI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbYCTEKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:10:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:9967 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYCTEKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VKc9iU3NnhIjFoV8KnkfL+PX/YQ4r897zHlnuGudI1E+3BRtN8jgNOFWMyvUr0McKcBDJfDnWEI7CUFUMVpJBXR8rFxjlkQWT43UuAmas77KqyUzsSyf64NSQrWpaNXo0ywAW66aF693tD0gpmIfNo2sXAKGxS6OrivPeEeXohY=
Message-ID: <dc84318c0803192110xe9cc515s49350923cdc88869@mail.gmail.com>
Date: Thu, 20 Mar 2008 12:10:49 +0800
From: "Daolong Wang" <ahlongxp@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH]CHECKPATCH:fix misleading output on spaces/tabs error
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <dc84318c0803192108l28292288yec6f75b79aa65e80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dc84318c0803182006u46b4ac2aj8d7a127963a0d5f3@mail.gmail.com>
	 <20080319141355.GC8590@shadowen.org>
	 <dc84318c0803192108l28292288yec6f75b79aa65e80@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
 >  Except that it says "use tabs not spaces when you should use tabs" and
 >  doesn't actually tell us what the error was, nor how to correct it.  So
 >  its not really any better than the original (which is also useless in
 >  this regard).
 >
 >  How about:
 >
 >         "code indent should use tabs where possible"
 >
 >
 My point is the original isn't good.

 And about the replacement, that was just my suggestion.
 We can choose one that'll please everyone.
 In fact, either mine or yours is much better.

Add cc, Sorry for repeating.
