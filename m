Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849Ab0AWSRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0AWSRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 13:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228Ab0AWSRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 13:17:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:42956 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0AWSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 13:17:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=XKOAcUHQXyZ+xPyFyQvKRgJ8ZvI6Kqtzub8pnDJqSTIM+XusTssSEJf3UjkHMcFyj4
         NBxD2ORLLNMbjVsVY3LgQc15VbunOJxZqyGagvxpa8vJToy5v8tDpiB7Ju1FvWwkpgTc
         wxehFZNSSQch9JLb6kNTs1G6hGw5Sw2o96SVU=
Message-ID: <4B5B3D41.8010909@gmail.com>
Date: Sat, 23 Jan 2010 19:17:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, zhenyuw@linux.intel.com,
       yakui.zhao@intel.com
Subject: Re: i915: gpu wedged [was: mmotm 2010-01-15-15-34 uploaded]
References: <201001152359.o0FNxVne006113@imap1.linux-foundation.org> <4B5AF1E5.1070304@gmail.com>
In-Reply-To: <4B5AF1E5.1070304@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2010 01:56 PM, Jiri Slaby wrote:
> and kernel says:
> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> render error detected, EIR: 0x00000000
> [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5
> (awaiting 153151 at 153150)
> [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -5

And it happens pretty regularly when accessing digitalnitelevize.cz with
firefox 3.6. Maybe some kind of flash crud triggers it?

-- 
js
