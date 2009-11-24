Return-Path: <linux-kernel-owner+w=401wt.eu-S933615AbZKXRBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbZKXRBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933594AbZKXRBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:01:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933478AbZKXRBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:01:34 -0500
Message-ID: <4B0C116C.5010106@redhat.com>
Date: Tue, 24 Nov 2009 19:01:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: The -next kernel no longer boots on kvm in 32bit mode
References: <20091124145855.2b73892e@lxorguk.ukuu.org.uk>
In-Reply-To: <20091124145855.2b73892e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 04:58 PM, Alan Cox wrote:
> 64bit Intel host system
> Fedora host environment
>
> 32bit guest built with CPU i686 and no PAE support
>
> This now momentarily flickers up something then reboots back to the BIOS.
>
>    

Any chance of a bisect to find out where this was introduced?

It's worth upgrading to at least F12 in case this is a kvm bug.

-- 
error compiling committee.c: too many arguments to function

