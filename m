Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0CDPF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:05:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:10899 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab0CDPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:05:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=c1faKsSLXeMYg+o5nJjkgFUxAUw+nK+MbVvSB12qJxJ9e7C07bTNspo5/HrSTR4dw8
         Z9G14Q2XcRYZYmXimugWxdpTF8s764YhdVK4AxBZORBvUA4ttzg83Svg0Au305lH2jfy
         u2idQ2o7lrSmplmEJEJsMZa58n1gSEmDja2bA=
Message-ID: <4B8FCC4D.6040202@gmail.com>
Date: Thu, 04 Mar 2010 16:05:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-11.2 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: no boot with NO_BOOTMEM=y [was: mmotm 2010-03-02-18-38 uploaded]
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org> <4B8FC98E.3070203@gmail.com>
In-Reply-To: <4B8FC98E.3070203@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject fixed.

On 03/04/2010 03:54 PM, Jiri Slaby wrote:
> On 03/03/2010 03:39 AM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
> 
> Hi, the kernel does not boot in qemu-kvm with NO_BOOTMEM=y. The last
> message is 'Booting the kernel.'

-- 
js
