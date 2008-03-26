Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbYCZMDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbYCZMDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbYCZMDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:03:41 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:62336 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbYCZMDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Es+pBvKua+TdHcVQgMQ99A7VW8N4DZQiN7Ou71JFAlb52FgHp17zDJQFX1+UQWP1OP5qdvCrHP1h145HZRuKpi297ie5d5ApaKG7OZKbwy4deJ7zvzNDK2Ke5YIELFbSqWyyEXMvwIK7ZTTb2P/CVvrhhBP8vqvDQby3qFa0GJY=
Message-ID: <87a5b0800803260503g3a2ab9a4t916239574cd35ddf@mail.gmail.com>
Date: Wed, 26 Mar 2008 12:03:39 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu, apw@shadowen.org,
       jirislaby@gmail.com, viro@zeniv.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080326115853.GE22847@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080326102654.GB22847@logfs.org> <20080326112311.GG17176@elte.hu>
	 <20080326114142.GD22847@logfs.org>
	 <20080326.044802.107678511.davem@davemloft.net>
	 <20080326115853.GE22847@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 11:58 AM, Jörn Engel <joern@logfs.org> wrote:

>  What is the reason why (void *)foo is better than (void*)foo?  Just that
>  fact that by random chance one them them became more common in our
>  codebase and the minority always has to give in?

It doesn't matter. This is the crux of all interminable coding style
discussions. There is no objectively best coding style. Pick one,
stick to it. That's all that matters.

Linux happens to have a particular coding style, GNU has another. When
I hack Linux code I use one style, when I hack GNU coee I use another.
Arguing about it is a waste of time.
