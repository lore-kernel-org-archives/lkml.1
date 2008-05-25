Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYEYHSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYEYHSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 03:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYEYHSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 03:18:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:55563 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYEYHSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 03:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rwzSleAx2u1IhBvtHcv7jOI7QSpdR4S8b2tHrbm62aluFVsodtDnAH7x3v9Kutj6PUuaOESUm3cBLMbg6ATIc//U14a0YqFLJ8gtAtI7r6wfqN6vCa1eRzmLX3EiKsnGIpzgLlg5eNBKWKa0cyGtEwRNVuOsQMgNK+EmAelSfEU=
Message-ID: <e2e108260805250018i774eaab3o17f3a1446f758bc7@mail.gmail.com>
Date: Sun, 25 May 2008 09:18:40 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
Subject: Re: Inserting code from userspace to kernel space
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 2:41 PM, Bosko Radivojevic
<bosko.radivojevic@gmail.com> wrote:
> I'm looking for a way to insert code from user space to the kernel
> space, but without using kernel module.

That would create a huge security risk. The number of Linux-specific
viruses is currently very limited, and I'd like to keep it that way.

Are you familiar with user-space device drivers ?

Bart.
