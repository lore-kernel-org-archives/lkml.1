Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYGPU7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYGPU7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbYGPU64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:58:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:19453 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbYGPU6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KBNdE0UkUtDH12E/6gVlHkq69CI8UzlI8UakOh2gpZQm89EZHsPo/SbwJh4RFaXa4z
         oJOLv+xKde6YYJmxMk9IiO30Pf7vBh1cA+cBN4pNbZHrA2aOtnyDTuvxvuLnNSOD0gRi
         FJ2p2sugG8DL9lG4n3sa2XFboPlQA6VFk9D2A=
Message-ID: <84144f020807161358g57eed242i9b6d11738735ed3@mail.gmail.com>
Date: Wed, 16 Jul 2008 23:58:54 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: SLUB: simplify re on_each_cpu()
Cc: cl@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080716172902.GA5176@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716172902.GA5176@martell.zuzino.mipt.ru>
X-Google-Sender-Auth: d3c4b0e77eb5bd32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 8:29 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> on_each_cpu() expands to function call on UP, too.
>
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Applied, thanks!
