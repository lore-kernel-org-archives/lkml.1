Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbZKAMYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbZKAMYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 07:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZKAMYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 07:24:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58502 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbZKAMYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 07:24:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AED7DFC.2030504@s5r6.in-berlin.de>
Date: Sun, 01 Nov 2009 13:24:28 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
CC: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/16] trivial: fix assorted spelling typos
References: <b8bf37780910310242v46cca93dl6d2c13d286085b1b@mail.gmail.com>
In-Reply-To: <b8bf37780910310242v46cca93dl6d2c13d286085b1b@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

André Goddard Rosa wrote:
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -741,7 +741,7 @@ int security_bounded_transition(u32 old_sid, u32 new_sid)
>  		goto out;
>  	}
> 
> -	/* type/domain unchaned */
> +	/* type/domain unchained */
>  	if (old_context->type == new_context->type) {
>  		rc = 0;
>  		goto out;

unchanged?
-- 
Stefan Richter
-=====-==--= =-== ----=
http://arcgraph.de/sr/
