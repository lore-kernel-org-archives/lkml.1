Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbXEaTyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbXEaTyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759467AbXEaTxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:53:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:61191 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239AbXEaTxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jrB+vy/XpH3x8c70n+byO7mo0qigMwvffSUevDoDBxCODbGjC9CS+qR46tEu8KWvI0NNKzS0R+ccUrjO0r8dxiyN2BAKssm7DKbWlhHNtYRMSW8KJaaBzSrHRE9gKCQL9m9i0hqcc/yVqfjmlEuUkKpehtypkrpDdJIcTDozspg=
Message-ID: <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
Date: Thu, 31 May 2007 15:53:49 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Renato Golin" <rengolin@gmail.com>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <200705210016.20794.dtor@insightbb.com>
	 <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
	 <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com>
	 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz>
	 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com>
	 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz>
	 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com>
	 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Renato Golin <rengolin@gmail.com> wrote:
>
> Now, why joydev's input_dev is reporting -127, 127 just for the two first axis?

Is it getting hit with HID_QUIRK_BADPAD? What does evtest utility show
for the device?

-- 
Dmitry
