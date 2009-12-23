Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZLWKXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZLWKXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZLWKXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:23:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39583 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZLWKXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:23:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=ndOf6NRXmt6j0OsJ5cH12cvLwejLGIaOPWu7gWTCco/gkJ3maGJMXJtlaS/kZEP5Y2
         r7O+mx2RxzsXfqdCUbcWhwpGg7alFs0dxfn+Quqgx/7nYhxhpogqq/PPta2uihUGRHJj
         q7R9A4m5Vl3e3fIYqzoqtEtnIK/A+TCutZuug=
MIME-Version: 1.0
In-Reply-To: <df5e30c50912220327o68d9d04al680aa7fbdd3e32f1@mail.gmail.com>
References: <df5e30c50912220327o68d9d04al680aa7fbdd3e32f1@mail.gmail.com>
Date: Wed, 23 Dec 2009 18:23:16 +0800
Message-ID: <df5e30c50912230223g7c0ec2e9i8c5fdf0acb702085@mail.gmail.com>
Subject: Re: Question: sRIO static ID allocation without enumeration
From: Jian Wang <dominicwj@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody could provide me this help? Any comment is much appreciated!

On Tue, Dec 22, 2009 at 7:27 PM, Jian Wang <dominicwj@gmail.com> wrote:
> Hi,
>
> I have one question about the RapidIO. The current Linux freescale MPC85xx
> driver fsl_rio.c enumerates the sRIO network and allocate device IDs to its
> link partners, but I want to statically assign device IDs to the sRIO
> devices in the sRIO topology. How could I do this to stop the driver from
> enumerating the network? Thanks a lot!
>
> BR/Dominic
>
