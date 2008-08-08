Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbYHHSXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbYHHSXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYHHSX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:23:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:47775 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYHHSX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=H1gORmDAdZOTaboStd+oI+S6cQPYQ4CdqONdA2BuDgKX/gYdMQYlkLozRdKNW/URk1
         sjbiod8fu2KHFmtrM2JCIn5ed9AXE8rBok58FRd23ZjhgPKf7UKyEZvxc89e2jzRCffx
         ZBEcWd1V/ppm8utCwAp7izSvCWwo45V45C7DY=
Message-ID: <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
Date: Fri, 8 Aug 2008 11:23:25 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Thomas Renninger" <trenn@suse.de>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Zhao Yakui" <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <200808081430.43012.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	 <514e099a0808080310n15d56d79k98587ca73111db59@mail.gmail.com>
	 <514e099a0808080343y41f279fbhc10b1539bfddb548@mail.gmail.com>
	 <200808081430.43012.trenn@suse.de>
X-Google-Sender-Auth: b9ed179d8da818b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Try updating the BIOS.
> I expect your CPU is too new and the BIOS cannot export the correct freq
> values for the specific CPU yet.
>
>      Thomas
>

The BIOS is already at the latest version :( Is the above comment the
only possible reason for the issue?

-SK
P.S: Thoman, I initially replied only to you. Sorry for the double email.
