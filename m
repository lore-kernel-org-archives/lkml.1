Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbXLMNla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbXLMNla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXLMNlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:41:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:65227 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbXLMNlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:41:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m4dOvNU4XSi6uysmiKwbZ2hRd6sjIC1+ytBChaKFl9tNVBItvwqSCU6dgYKSVyb9Vw6PQTS7RdqO/MFDtVx2LbIEpG5pGmbRJ58yjxD8R+PMHm3x8af4mavxBXRNWEQ+DVuAf26jjZ0dFVgoqcClxVzz1EMjYAlfREBzBsVN5/U=
Message-ID: <d120d5000712130541x13a645e0x7f2f3b31d80e1f35@mail.gmail.com>
Date: Thu, 13 Dec 2007 08:41:20 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 09/60] Input: ALPS - add signature for ThinkPad R61
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20071213065127.GJ6867@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213064518.328162328@mini.kroah.org>
	 <20071213065039.GA6867@kroah.com> <20071213065127.GJ6867@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Dec 13, 2007 1:51 AM, Greg KH <gregkh@suse.de> wrote:
> 2.6.23-stable review patch.  If anyone has any objections, please let us
> know.
>
> ------------------
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> changeset f493018ebc3f94d64e12bc848db0906700bf73a2 in mainline.
>
> Input: ALPS - add signature for ThinkPad R61
>

Please drop this one... I think I have seen a report where it
interferes with a regular logitech mouse. I will see if I fix it for
.24 or revert if from mainline. Definitely not for stable.

-- 
Dmitry
