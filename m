Return-Path: <linux-kernel-owner+w=401wt.eu-S932983AbZJHSi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbZJHSi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbZJHSi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:38:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:56582 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911AbZJHSiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XGDWpCwcfbOCu1Y/3h9lAFFznwPDogAygbS6cwPEwhqlBkImSK0JeS9wmZM9GHNgFr
         BB84Uj6djy5i0CKwvwg8W81ZJ0BGgdGDy0k8Xf5h0Cx4tE+iEGLMv1Eg2asyG+nj3lyJ
         eKraC9kJ9PDRALBq/SImWLknwwASmT5yPisSM=
MIME-Version: 1.0
In-Reply-To: <20091008175939.GA31126@logic.univie.ac.at>
References: <20091008175939.GA31126@logic.univie.ac.at>
Date: Thu, 8 Oct 2009 20:37:18 +0200
Message-ID: <8db1092f0910081137m1b503b32hb93d50d85aca4c23@mail.gmail.com>
Subject: Re: Allocated Mem - 700MB missing
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andreas <andreas2@logic.univie.ac.at>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Look at Your config option:
CONFIG_HIGHMEM4G
CONFIG_NOHIGHMEM

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
