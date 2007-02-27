Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbXB0Xne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbXB0Xne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXB0Xne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:43:34 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:18920 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbXB0Xnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:43:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fiRmiQ5ZZfEqSc7L5hEGXFeaeoSGi6QqDiBpWKNs+KdHVTPKpqeAbK3h65tHsQdyySnR8+eS+emR0Zf8wb6nvEXX6Sv3+97ideZ8Zf2RoZSHmevAZXiW0qoIDlbV3J4SXvxmKkEmNg3hIpwH8dbHfQ9Ufq9dZUJVQCvnfkXFHlE=
Message-ID: <9d2cd630702271543i1e7931f8kd786570d2ff60adf@mail.gmail.com>
Date: Wed, 28 Feb 2007 00:43:32 +0100
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: Menuconfig has butterfly effects?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200702271812.42616.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702271812.42616.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/2/28, Rob Landley <rob@landley.net>:
> I ran "make ARCH=x86_64 menuconfig", did a lot of editing, and saved
> the .config.  Then I copied that to a backup, ran "make oldconfig" on the

I'd try with "make ARCH=x86_64 oldconfig"

Gregor
