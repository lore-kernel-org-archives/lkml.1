Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbXBDTjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbXBDTjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXBDTjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:39:23 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:55896 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbXBDTjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:39:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hVL5cKOhU3ophpL+t/CuQ3dyYV+sPF93myRQ0xqRLOJasd61mjffuNfQQCLR4XqeZuQ7y4xmYNPj33xHvuHlrC7yUlmB36U7oGL6NofMcLZ0cFeGJHR3oaqSuwFMYNBchbALyX8G/GiNmUFsUBzCRt1qzg4jSKTvQ6BCvR/02aM=
Message-ID: <8d158e1f0702041139k658e6d6dv52e7b3c68ef146e1@mail.gmail.com>
Date: Sun, 4 Feb 2007 20:39:21 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: More pata_ stuff
Cc: "Alistair John Strachan" <s0348365@sms.ed.ac.uk>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <20070204194909.136dccc5@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
	 <45C619FC.3040804@shaw.ca>
	 <8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
	 <200702041910.46421.s0348365@sms.ed.ac.uk>
	 <20070204193441.6746bbca@localhost.localdomain>
	 <8d158e1f0702041129n578a4a58xe8cb2a5f4da69284@mail.gmail.com>
	 <20070204194909.136dccc5@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
\
> OLDPIIX is for "old" PIIX devices only - from pentium era. It does not
> cover the later chips at all

Well, neither driver works, as you can see in my config I have the
"OLD" driver and the "new" driver, neither driver makes my controller
being detected...

Patrick
