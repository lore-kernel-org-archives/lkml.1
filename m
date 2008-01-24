Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbYAXUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbYAXUKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYAXUKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:10:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:35893 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYAXUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:10:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XuBgJZjufQTZQwV/r6QsjRbYWo582XzJ8+WcTMnfslRa1+ng6sJBL7tDVx2RNQq2nJYDrbKRJtJVacsoGzoZqdALbvlF0KF6C7LmKgAAmgVdNRYFLw/zKRw1ZT4iQv3Z9tcwvXuamRK9PdTpMzhmuGBGld1DMeS+BHdOPpl2jyo=
Message-ID: <84144f020801241210l2bcd5072i78a1a32a078da18d@mail.gmail.com>
Date: Thu, 24 Jan 2008 22:10:00 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Cc: "Greg KH" <greg@kroah.com>, "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801242057.59226.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
	 <20080124180313.GA16006@kroah.com>
	 <Pine.LNX.4.64.0801242122200.17171@sbz-30.cs.Helsinki.FI>
	 <200801242057.59226.oliver@neukum.org>
X-Google-Sender-Auth: 027fca5083b02054
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Jan 24, 2008 9:57 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Are you proposing to mount a _character_ device?

/me looks

Yeah, I am proposing to mount whatever usb_register_dev() pops up in
/dev (which indeed is a character device). Is that a problem?

                       Pekka
