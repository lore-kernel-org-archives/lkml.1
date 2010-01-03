Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050Ab0ACRpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0ACRpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 12:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840Ab0ACRpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 12:45:19 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36751 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab0ACRpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 12:45:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=QAFY/0/bsdy2vb0d5yPQlgMGWWv0QQVv/Ehh/rUwC+N0/zWCjaIBwtxrtLubgLFKBS
         TeDmQh92GNOvgtdPqCS8FQ64Q06R81ubqkeSYlggAvX8DsTsLpwjJnOoTyfyvxVLhrZM
         cO9/6u8XGFc0FPTp2lRuIkuDS+fGVEWMWbIas=
MIME-Version: 1.0
In-Reply-To: <4B40CC74.1060508@gmail.com>
References: <4B40CC74.1060508@gmail.com>
From: roel kluin <roel.kluin@gmail.com>
Date: Sun, 3 Jan 2010 18:44:57 +0100
Message-ID: <25e057c01001030944h5c9c84e1i4712ee48d7cead67@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Wrong variable tested
To: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 3, 2010 at 5:57 PM, Roel Kluin <roel.kluin@gmail.com> wrote:
> The return of the function sdio_readb() was not tested.

Please ignore, as Joe Perches pointed out it's wrong.

Roel
