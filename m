Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbYHMKbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbYHMKbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYHMKbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:31:41 -0400
Received: from ethlife-a.ethz.ch ([129.132.49.178]:57515 "HELO ethlife.ethz.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752622AbYHMKbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:31:41 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Aug 2008 06:31:40 EDT
Message-ID: <48A2B677.90400@jaeger.mine.nu>
Date: Wed, 13 Aug 2008 12:24:55 +0200
From: Christian Jaeger <christian@jaeger.mine.nu>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.6.0-rc3
References: <7viqu5nw9x.fsf@gitster.siamese.dyndns.org>
In-Reply-To: <7viqu5nw9x.fsf@gitster.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> The last rc before the final, 1.6.0-rc3, can be found at the usual places:
>   

The git://git.kernel.org/pub/scm/git/git.git repo is missing a 
v1.6.0-rc3 tag.

I've checked the current master branch (04c6e9e), but it does not 
contain the gitk fix from Alexander Gavrilov ([PATCH (GITK BUGFIX)] 
gitk: Allow safely calling nukefile from a run queue handler.); Paul 
Mackerras said he applied it (somewhere); I just think that this is an 
issue that will probably bite many people and so should be fixed in 1.6.0.

Christian.

