Return-Path: <linux-kernel-owner+w=401wt.eu-S1761528AbYEMUsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528AbYEMUsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbYEMUsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:48:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:48457 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYEMUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hT/+gF+sTucZY1TuqSDdKDRuh3PIioSuWj64mmJPt7muphvvWXdsEAlC0yKXTjUEpAdpd90q6wE6SeowUTgB/9dmt0bwH2wwfbqwMGHMKISme9mkf3Gw0YB+zpiLqmw4bf+nsmjVRf68UJYKF3xctfh0HjBtCWj49bfCvk4zx2A=
Message-ID: <4829FE73.20709@gmail.com>
Date: Tue, 13 May 2008 22:47:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Eric.Brunet@lps.ens.fr
CC: Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Bug with keyboard input
References: <20080513092735.GA32087@platane.lps.ens.fr>
In-Reply-To: <20080513092735.GA32087@platane.lps.ens.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2008 11:27 AM, Eric.Brunet@lps.ens.fr wrote:
> Hi list,
> 
> With uptodate Fedora 7 (kernel kernel-2.6.23.15-80.fc7) on a Dell D430
> laptop.

Please file a bug on redhat bugzilla. They (like other distro providers) have 
bunch of patches included in it.

Or try some kernel.org tree and recheck if the problem persist, then report it here.
