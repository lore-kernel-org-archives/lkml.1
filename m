Return-Path: <linux-kernel-owner+w=401wt.eu-S1763548AbYEGLQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763548AbYEGLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYEGLQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:16:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:13968 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbYEGLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=neLUTHEM6zUz5gC4KXWfZWtNd+8j36170VuP7sSzUAbIG9CMByU7onF3VewS8vQntnlMPPNOwk/rIFvv1DvFXaG0zVm6sb/nXR2s2MqY/AJX+8arYpYBghFi9YawKEZFlo82u2Mf90+ChlluGA4mPCVe+TlrKqrEsi/ump3yrto=
Message-ID: <84144f020805070416t321928ben4cd66a8235a74cbc@mail.gmail.com>
Date: Wed, 7 May 2008 14:16:41 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: JosephChan@via.com.tw
Subject: Re: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver
Cc: akpm@linux-foundation.org, geert@linux-m68k.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67724@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67705@exchtp03.taipei.via.com.tw>
	 <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67724@exchtp03.taipei.via.com.tw>
X-Google-Sender-Auth: c8b0535829d9117a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

On Wed, May 7, 2008 at 1:55 PM,  <JosephChan@via.com.tw> wrote:
> Signed-off-by: Joseph Chan <josephchan@via.com.tw>

The patch has plento of coding style problems so you probably want to
run scripts/checkpatch and re-submit. Is the documentation available
somewhere for this device btw?
