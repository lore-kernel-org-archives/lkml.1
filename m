Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYHISqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYHISqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYHISqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:46:25 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:15693 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYHISqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QKKobUkPgk1cvZTst073WIPtYBVpQoURpPQ7A4rr6PKZ87KcerJI2PMJh8v9DB6xz2
         Vrhl6BLvtebwaicBvwycZiwZVCZDHkI5y/iljLvLIkQUVroWJmbrrBOM75jgUfDgRYXL
         0ptYiZTU4KLWaB9cLKuDglxAvUaDMGgQKddEg=
Message-ID: <b637ec0b0808091146o7ce25033m13b544ae7d8b5352@mail.gmail.com>
Date: Sat, 9 Aug 2008 20:46:21 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: New conflict message in latest GIT
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Renninger" <trenn@suse.de>
In-Reply-To: <20080809190336.05e84068@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>
	 <200807231256.42743.bjorn.helgaas@hp.com>
	 <b637ec0b0807231250g3e5b29eak8fbba41b69816351@mail.gmail.com>
	 <20080809181358.5c9da790@hyperion.delvare>
	 <b637ec0b0808090932l4d21d973we160c145f007da7c@mail.gmail.com>
	 <20080809190336.05e84068@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Aug 9, 2008 at 7:03 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Sat, 9 Aug 2008 18:32:31 +0200, Fabio Comolli wrote:
>> Anyway, as usual linux is not supported at all on this laptop, it came
>> with XP. One thing that puzzles me is why bothering adding a
>> monitoring chip for which drivers do not exist for any OS?
>
> If you refer to the PC87591: that's a Super-I/O chip, including many
> different functions. Hardware monitoring is only one of these
> functions. Manufacturers might be interested in some of the other
> features and chose this chip because of them. Windows doesn't support
> hardware monitoring at all without 3rd party tools anyway, so that's
> hardly a decision factor for vendors.
>
> Additionally, on laptops, thermal management is most often done by ACPI
> rather than native OS drivers. Maybe the ACPI implementation in your
> laptop actually gets the temperature from the PC87591.
>

Oh, I see. Thanks for the explanation.

> --
> Jean Delvare

Regards,
Fabio


>
