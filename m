Return-Path: <linux-kernel-owner+w=401wt.eu-S934705AbYBAArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbYBAArT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYBAArE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:47:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:37068 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762142AbYBAArD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:47:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nJpicfjL5ne4FHqqeL1NsXF/diUjIe0KuE+tKD9BRswdGavrlcit09OUrZBYNBaOzhxtAjY8KyrndrZx0V1Woo6dI2AbJSs/4yZhlOr9LGg6JwXfeSg82csPGVgzpc/B/OYcTqejCd0p/EvSawAAatiiP2SPJCzR3WiZ/V/WtVg=
Message-ID: <2c0942db0801311646s40368a89r537a7d576ba57981@mail.gmail.com>
Date: Thu, 31 Jan 2008 16:46:57 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: how to tell i386 from x86-64 kernel
Cc: "kernel list" <linux-kernel@vger.kernel.org>, jikos@suse.cz
In-Reply-To: <20080201004212.GA2818@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080201004212.GA2818@elf.ucw.cz>
X-Google-Sender-Auth: 8e734f7704ed6b4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 4:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Quiz: on a booted system, how do you tell 32bit from 64bit kernel?

Uhm, is this a trick question? What's wrong with uname(2)?
