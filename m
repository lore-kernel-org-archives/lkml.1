Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbXGaV2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbXGaV2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933950AbXGaV1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:27:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:6077 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765202AbXGaV1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:from:cc:content-type:mime-version:references:content-transfer-encoding:message-id:in-reply-to:user-agent;
        b=ij2u423yv+8YpCNCjMqEi33M3QGDUInwM0KqBqQKBkIA0zUlgDzYhKbBeJRJ2e2CeOKM8TTfCBIBt8cWFxZNs40Cxthq39furesBddItpIycjXIAHDb7/a8SeSpZtA1V3ygHsP71OiKVAaaf+LbQmLInZGpjH3munPIrvHrVyRY=
Date: Tue, 31 Jul 2007 23:27:47 +0200
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: Reboot hang
From: kriko <kristjan.ugrin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.twci6be2atcbto@linux.site> <46AF9DC8.7080103@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-ID: <op.twclwllkatcbto@linux.site>
In-Reply-To: <46AF9DC8.7080103@gmail.com>
User-Agent: Opera Mail/9.22 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 22:38:32 +0200, Rene Herman <rene.herman@gmail.com>  
wrote:

> Does it matter at all if you add "reboot=b" (other options w, c, h) as a  
> comand line parameter?
>
> Rene.

None of that parameters worked for me. It seems they do have some effects  
(judging by bios information screen), but they don't fix the problem.
I hope you understood where exactly it hangs (I don't know how is this  
screen called), so here is a quick shot of screen:
http://files.myopera.com/kriko/files/Photo0003.jpg

After "Verifying DMI Pool data" message it should start booting, but it  
doesn't.


-- 
kriko
