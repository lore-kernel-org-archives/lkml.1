Return-Path: <linux-kernel-owner+w=401wt.eu-S1765802AbYEGTHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765802AbYEGTHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbYEGTHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:07:15 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:58836 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651AbYEGTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p3SOZC1iZmXBYcbD75YIcZ/r21gJglIyA65A32tDqvsMFRzwbqkGU2+NQr3W21vIhGgkX3/pzWZpQITXM3YyPtW7CrJNHOx1jJcL8rBAX7oBJWQfe+Ni0waV++XmqubaFK912SwmqColrzMIl3NIuWGJgVECVTy2KXwx4UzBeN8=
Message-ID: <dd18b0c30805071207q1aaeb8daq7f63b02d3a58b5a@mail.gmail.com>
Date: Wed, 7 May 2008 19:07:11 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: nopage to fault
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4821F3EE.1010309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805071040i5e9c3d73uf60235b94dcce3c5@mail.gmail.com>
	 <4821F3EE.1010309@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 6:24 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 05/07/2008 07:40 PM, Justin Mattock wrote:
>
> > of the areas that I'm lost with is NOPAGE_SIGBUS for a return value.
> > in mm.h The only options I see is VM_FAULT_SIGBUS, VM_FAULT_ERROR. If
> >
>
>  The former, next time, google little bit, please.
>

Thanks for the help,
 you mean the former definition which was taken out "NOPAGE_SIGBUS",
or former as in an interface located somewhere in the kernel.
regards;


-- 
Justin P. Mattock
