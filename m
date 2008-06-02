Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbYFBLEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbYFBLEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYFBLEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:04:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:20114 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748AbYFBLER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CWZD8YaLXVf79Qg9aBFh7OBAXC7qwmhwUVaSrgRXbyAeX9zwN5qiguRjTAOxd87GfcSfxj7vGn4nwhCUadil6J/PdDqfI34I1gF6e7RY3TdOWsGzDhD+CDpFwzQZVMQyrEoC3xG8QynU6RZx+Zh81oUXknia0QWH0uXdVkBDlCo=
Message-ID: <84144f020806020404v430e63c6i71cafdda616a2512@mail.gmail.com>
Date: Mon, 2 Jun 2008 14:04:17 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [patch 01/15] security: pass path to inode_create
Cc: hch@infradead.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, agruen@suse.de,
       jjohansen@suse.de, penguin-kernel@i-love.sakura.ne.jp,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080529134903.615127628@szeredi.hu>
	 <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu>
	 <20080602060144.GA11564@infradead.org>
	 <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu>
	 <20080602091341.GA8011@infradead.org>
	 <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu>
	 <20080602093630.GA25254@infradead.org>
	 <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu>
	 <20080602104203.GA21898@infradead.org>
	 <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu>
X-Google-Sender-Auth: 172bbe65d84e75bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 1:55 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> You can argue against the concept of apparmor itself, but you better
> argue with Crispin, because I'm quite clueless about that part.  When
> you've convinced him (and Linus (and Ubuntu, and SUSE, and Mandriva))
> that apparmor is a stupid idea, then I'll give up.  Good luck with
> that!

But then I guess you can just by-pass the VFS maintainers and send
your patches directly to Andrew/Linus. Good luck with that! :-)
