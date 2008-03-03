Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYCCQlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYCCQlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYCCQlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:41:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:57729 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYCCQlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:41:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=O9Hsu22abL6NSC4I28KskAquk4OWyU+No2IO0PlvnhlZh1oWZypqZ9twq4TIT+3j7kHmjAudIIHsCQinxAODKqEIrYX0p7Q6oSYbam1iEsPKjeG3a7Qz0kcBE++kvtL4jIa9ZGL4VeC43y1IFsw7Oy6lHzn5zm7Q52oL6H/xcwI=
Message-ID: <2f11576a0803030841g43f673d9w6b9a5cc8c6e35340@mail.gmail.com>
Date: Tue, 4 Mar 2008 01:41:06 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Cc: "Rick van Rein" <rick@vanrein.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080303141438.GD12606@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080302134221.GA25196@phantom.vanrein.org>
	 <20080303141438.GD12606@elf.ucw.cz>
X-Google-Sender-Auth: c029c396608e475a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  > This is the latest version of the BadRAM patch, which makes it possible to
>  > run Linux on broken memory.  The patch supports the use of a lesser grade
>  > of memory, which could be marketed more cheaply and which would thereby
>  > decrease the environmental stress caused by the process of (memory) chip
>  > manufacturing.
>
>  What is wrong with mem=exactmap?

Agghh,
I had forgotten that.

you are right, may be.
