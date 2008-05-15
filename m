Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYEOL17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYEOL17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYEOL1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:27:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:26991 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYEOL1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=q3SF+GJo4dZ/qJxvzAZ9Sasbjk+s4lQCepY/w9D0/uZ68/H4i3rz+rSH+kwR25LqOJDitZMkkAeyesKk5KCqM9ITkDyz8vdjrvqayWK5Zwj4m7UuiSMYtVqoj9ay6NiTTVuprSzt8QVomi8V3ybJwRbVc9evRsE8QiFUtyp/lVk=
Message-ID: <482C1E30.2030307@gmail.com>
Date: Thu, 15 May 2008 13:27:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Eric.Brunet@lps.ens.fr
CC: Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Bug with keyboard input
References: <20080513092735.GA32087@platane.lps.ens.fr> <4829FE73.20709@gmail.com> <20080514112701.GA9639@platane.lps.ens.fr>
In-Reply-To: <20080514112701.GA9639@platane.lps.ens.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric.Brunet@lps.ens.fr napsal(a):
> On Tue, May 13, 2008 at 10:47:47PM +0200, Jiri Slaby wrote:
>> On 05/13/2008 11:27 AM, Eric.Brunet@lps.ens.fr wrote:
>>> Hi list,
>>>
>>> With uptodate Fedora 7 (kernel kernel-2.6.23.15-80.fc7) on a Dell D430 laptop.
>> Please file a bug on redhat bugzilla. They (like other distro providers) 
>> have bunch of patches included in it.
>>
>> Or try some kernel.org tree and recheck if the problem persist, then report it here.
> 
> Well that's not the sort of things distributions are patching, 

Why do you think so? It could have been caused by some core patches or whatever.

> but you're
> of course right, it is better to make sure. So I downloaded the sources
> of a linux-2.6.25, copied the fedora .config, ran make oldconfig and
> made the default answer to every question. With that pristine kernel, the
> bug is still here.

Then please CC input people on your original post.
