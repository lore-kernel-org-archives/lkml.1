Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZKVTfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZKVTfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 14:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZKVTfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 14:35:06 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38255 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZKVTfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 14:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qgx36EOAdvKYpgh4ftrGvnnxpLvq5t5Mba0vmjZdG7fMf2n4Z/eDXk/p5Q3PWLETIy
         q4V+epJhKDirZJbzeOfz0PI7atFG1MdOMqsnLw7vp1lHrqKZ/wAUTe4RS6Dq8ycEqXQp
         Xm0DXHwC2unYf+vAhpm84ZLf/jj7mRvLj/Zog=
MIME-Version: 1.0
In-Reply-To: <20091118223851.GA5191@ami.dom.local>
References: <81bfc67a0911111448q2e7938fcq18adf2454d6bc8f1@mail.gmail.com>
	 <81bfc67a0911120546g26627ac5q5860d85f446b29bb@mail.gmail.com>
	 <4AFC5C58.9030207@gmail.com>
	 <81bfc67a0911130825o6d9b93b2he70677157ad889f2@mail.gmail.com>
	 <20091113211640.GA2540@ami.dom.local>
	 <81bfc67a0911180159g45a45675k44ce3f251c6bddea@mail.gmail.com>
	 <20091118135136.GA9224@ff.dom.local>
	 <81bfc67a0911181021n1b969565y4a39b181360b5e92@mail.gmail.com>
	 <20091118201034.GA3060@ami.dom.local>
	 <20091118223851.GA5191@ami.dom.local>
Date: Sun, 22 Nov 2009 14:35:10 -0500
Message-ID: <81bfc67a0911221135y300841f2i8e78417600528cd5@mail.gmail.com>
Subject: Re: large packet loss take2 2.6.31.x
From: Caleb Cushing <xenoterracide@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

haven't had time to do a test yet. but would it be of any use for you
all for me to throw another nic (it'd be a different driver for sure)
in this box and test that on a problematic kernel? I have some but not
with me.

On Wed, Nov 18, 2009 at 5:38 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On Wed, Nov 18, 2009 at 09:10:34PM +0100, Jarek Poplawski wrote:
>> On Wed, Nov 18, 2009 at 01:21:19PM -0500, Caleb Cushing wrote:
>> > yeah testing it under my known working config first. I'll get back w/ you later.
>>
>> Btw, since dropping at hardware (NIC) level seems more likely to me,
>> could you send 'ethtool eth0', and 'ethtool -S eth0' after such tests
>> (both sides).
>
> Hmm... and 'netstat -s' before and after the test (both sides).
>
> Jarek P.
>



-- 
Caleb Cushing

http://xenoterracide.blogspot.com
