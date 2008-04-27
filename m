Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbYD0HTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbYD0HTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 03:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYD0HTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 03:19:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:56330 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbYD0HT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uW3mssBJpZbowbTLqeGcGxpeZhXytKu3A3jyYmeezsBmk3QhFlBqSKSRx+BA5B93GojQHcTG0SHtUdFqec+rWygIk3+qRS58cfdZQGn/kQko04sxkIizXyyfXzb/nWthd5asedNcSaTG0qz9ZPCnyInOInZqKkYWFhuSCgQ7zJo=
Message-ID: <481428F7.4000803@gmail.com>
Date: Sun, 27 Apr 2008 09:19:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Brian S. Julin" <bri@abrij.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: OQO o2 extras driver, testers needed
References: <Pine.LNX.4.64.0804261711140.32339@sheavy.abrij.org>
In-Reply-To: <Pine.LNX.4.64.0804261711140.32339@sheavy.abrij.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2008 11:23 PM, Brian S. Julin wrote:
> 
> Code and writeup at:
> 
> http://www.abrij.org/~bri/hw/oqowmi.html
> 
> Anyone with a modicum of kernel skill and an OQO o2 is welcome/entreated 
> to give this a spin.  Once I have verification that a couple people 
> other than me have actually managed to use it, I'll work it up into 
> patch form.

If you want to get any feedback, you should include the patch or at least the file.

> P.S. any HOWTOs with a checklist on adding a simple driver to the build 
> system?

Documentation/kbuild/
