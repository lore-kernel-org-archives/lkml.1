Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZLBONy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZLBONy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZLBONx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:13:53 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:61968 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZLBONw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:13:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Sf58EPm8F0nkd9FgiMvXKlMHN5wLVgXBeerN4Q7T7kHZHeVrZs98EGNjLWC+wVFIT2
         bU0cj4iQcncp5fv0McRz+w0mymmnogGhW/d/WL7FX+lwljW+7ymuJuNORX0PELGsUnGT
         wgWoZGMQq5x6ohRtFhHsgyRcsA5WJw3dN7cAw=
Message-ID: <4B16761F.6020709@gmail.com>
Date: Wed, 02 Dec 2009 09:13:51 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Xiaochun Lu <xiaoclu@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Key change for TCP_MD5
References: <911b679e0912011627q568132e8x655f109c75030725@mail.gmail.com>
In-Reply-To: <911b679e0912011627q568132e8x655f109c75030725@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaochun Lu wrote:
> know rfc4808 is targeting to solve this issue. Does there any plan to
> implement rfc4808 for linux?
> 
There's a replacement effort at:

   http://www.ietf.org/internet-drafts/draft-ietf-tcpm-tcp-auth-opt-08.txt
   http://www.ietf.org/internet-drafts/draft-ietf-tcpm-tcp-ao-crypto-01.txt

Probably going another round with them before writing code for Linux.
