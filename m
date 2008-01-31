Return-Path: <linux-kernel-owner+w=401wt.eu-S1764769AbYAaD0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764769AbYAaD0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYAaDZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:25:52 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33540 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbYAaDZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:25:51 -0500
Message-ID: <47A13FBD.9080709@davidnewall.com>
Date: Thu, 31 Jan 2008 13:55:49 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Giridhar Pemmasani <pgiri@yahoo.com>, Pavel Roskin <proski@gnu.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>, rms@gnu.org
Subject: Re: ndiswrapper and GPL-only symbols redux
References: <20080129225701.GS8767@does.not.exist> <754585.89171.qm@web32403.mail.mud.yahoo.com> <20080130175447.GB29368@does.not.exist>
In-Reply-To: <20080130175447.GB29368@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> IANAL, but I have serious doubts whether putting some glue layer between 
> the GPL'ed code and the code with a not GPL compatible licence is really 
> a legally effictive way of circumventing the GPL.


Just to refresh my memory, I re-read the GPLv2, and specifically the
licence (COPYING file) that comes with Linux 2.6.23, and I see nothing
in it that suggests shims, wrappers or other glue-layers are forbidden. 
I see exactly the opposite.  This idea that some symbols may only be
dynamically bound to GPL code is fallacy.  In the preamble to GPLv2 are
words which make the position clear:

  "the GNU General Public icense is intended to guarantee your freedom
to share and change free software"

Childish games, for example blacklisting ndiswrapper, can be defeated,
using patches, by authors of affected programs or anyone else.  That's
the freedom guaranteed by GPL.
