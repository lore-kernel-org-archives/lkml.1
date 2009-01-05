Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZAEQFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZAEQFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbZAEQE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:04:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:2231 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbZAEQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:04:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Sv4J4nPAn/Fb/br9bPdEZGlQwLhQbglVujRDahzeLHAuHEV7kjPSkwZ1rxi/Anokxf
         YSz7E71XVkcCaFKeM8DWkXaeWKoLdy7/nNeYjmBAwArQd6L1JZL/g0sigdSuf8QDJNBk
         BieanwMJ7GZEdjmuUyc2q0BaqK4Fp1NfMNwGg=
Message-ID: <49622FA1.5060603@gmail.com>
Date: Mon, 05 Jan 2009 17:04:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1] IWL: fix WARN typo
References: <1231171404-22822-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1231171404-22822-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2009 05:03 PM, Jiri Slaby wrote:
> new kew -> a new key
...
> -		"no space for new kew");
> +		"no space for a new key");

There are more of them, hold on, I'll post an updated one.
