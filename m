Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYL2LMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYL2LMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYL2LL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:11:59 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48348 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbYL2LL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:11:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M+f4Mpr3t/xrDQyuszu9CHuIF4B/XY/WxAsGtUBKROOvVD3X9jbur3HkhJZkQEQevJ
         jhZxpLG4QlKTefidrthRz3lwgheLaAb+YAWiJGr/GSPGhmxLJEqG0I0gGxv1RrgjuDXO
         xaIvag/pwS6LQJLcbqszlZUTAsxGZApTFEj80=
Message-ID: <71cd59b00812290311v4a23582t7f883f3a4e6c3fbf@mail.gmail.com>
Date: Mon, 29 Dec 2008 12:11:55 +0100
From: "Corentin Chary" <corentin.chary@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Add EEE Bluetooth ACPI details
Cc: "Jonathan McDowell" <noodles@earth.li>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Len Brown" <lenb@kernel.org>
In-Reply-To: <20081203203429.GA24103@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203203111.GA28234@earth.li>
	 <20081203203429.GA24103@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 9:34 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Dec 03, 2008 at 08:31:11PM +0000, Jonathan McDowell wrote:
>> Although rfkill support for the EEE bluetooth device has been added to
>> 2.6.28-rc the appropriate ACPI accessor definitions were not added, so
>> the support was non functional. The patch below adds the get and set
>> accessors and has been verified to work on an EEE 901.
>>
>> Signed-off-by: Jonathan McDowell <noodles@earth.li>
>
> Acked-by: Matthew Garrett <mjg@redhat.com>
>
Hi Len,
Could you push this ?

Acked-by: Corentin Chary <corentincj@iksaif.net>

-- 
Corentin Chary
http://xf.iksaif.net
