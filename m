Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYKJOG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYKJOG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYKJOGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:06:18 -0500
Received: from hope.ime.usp.br ([143.107.45.8]:45388 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755008AbYKJOGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:06:18 -0500
Date: Mon, 10 Nov 2008 12:06:11 -0200
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
       Bugreport <bugme-daemon@bugzilla.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Rafael Wysocki <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       acpi-bugzilla@lists.sourceforge.net, rui.zhang@inte.com,
       rbrito@ime.usp.br
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends, but does not wakes up
Message-ID: <20081110140611.GA4450@ime.usp.br>
References: <20081106194724.GB15366@ime.usp.br> <20081107014535.GA19201@ime.usp.br> <1226044855.4913f5b7f2f45@webmail.ime.usp.br> <20081108075008.GA8177@ime.usp.br> <dd18b0c30811080020i23418742xc6388a5942456566@mail.gmail.com> <20081109024514.GA11744@ime.usp.br> <3DCE2017-408C-45E2-8E0D-3A474E8645F6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3DCE2017-408C-45E2-8E0D-3A474E8645F6@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Justin.

On Nov 08 2008, Justin P. Mattock wrote:
> Appologize if this is quite brief
> (sending from phone);
> For the long delay try comment #2
> Of:
> http://bugzilla.kernel.org/show_bug.cgi?id=11220
> Keep in mind msi.c might have been changed since then, so it might not  
> work

I checked this patch and it seems to be already incorporated into
2.6.28-rc3 (with a dry-run, it told me that it was already applied).

Thanks for the feedback anyway. I appreciate any help that I can take.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
