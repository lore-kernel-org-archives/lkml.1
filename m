Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbYLLSMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbYLLSMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757721AbYLLSMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:12:32 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:8134 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbYLLSMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:12:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IXUcfym2W3mhaKfdoxLqIduv0+BDZnx4JGYfZrR5xMdaVMlFMn5JAZDUnD+zouWzXO
         6xr/CK6uHc046a6TIL8ky1FDccb2cv8sN8e//sg6A+mk8u2sbD+BJ+Rs9JVU0/yDMO5q
         Or09MG611EX719AvclzHa5zV3LNARh3Mg+62E=
Message-ID: <f5cc88f60812121012p79313509uc33f8f5e1a984eb4@mail.gmail.com>
Date: Fri, 12 Dec 2008 16:12:29 -0200
From: "Marcello Henrique" <faraohh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Auto generate .config.
In-Reply-To: <87skotb9ca.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f5cc88f60812120747w47c762a7qcee62fdfa10d6ac6@mail.gmail.com>
	 <49428DF8.2090205@diamondcut.com.br>
	 <f5cc88f60812120820i4252962er2fa6d3483c2ae412@mail.gmail.com>
	 <87skotb9ca.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 15:18, Andi Kleen <andi@firstfloor.org> wrote:
> "Marcello Henrique" <faraohh@gmail.com> writes:
>>
>> The idea is that the kernel of my distribution is too fat and I only
>> generate a kernel module that I use automatically from a kernel fat.
>> understand?
>
> While it sounds like a good idea initially you'll regret it once you
> plug in some USB device and find that you miss its driver.
>
> -Andi
> --
> ak@linux.intel.com

In this case, generic usb driver with module in default.

-- 
Marcello Henrique
Associação Software Livre de Goiás (www.aslgo.org.br)
Cercomp - UFG (www.cercomp.ufg.br)
