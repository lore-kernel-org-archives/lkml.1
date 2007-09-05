Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbXIEHtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbXIEHtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 03:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbXIEHt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 03:49:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbXIEHt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 03:49:27 -0400
To: James Pearson <james-p@moving-picture.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Guy Streeter <guy.streeter@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <4474B7DB.8000304@moving-picture.com>
	<200605242029.k4OKTn9C031700@terminus.zytor.com>
	<447EF58C.6000605@moving-picture.com>
	<52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>
	<46C33700.1060605@zytor.com> <46D6CBED.4040301@moving-picture.com>
From: Anton Arapov <aarapov@redhat.com>
X-URL: http://people.redhat.com/aarapov
Date: Wed, 05 Sep 2007 09:49:22 +0200
In-Reply-To: <46D6CBED.4040301@moving-picture.com> (James Pearson's message of "Thu\, 30 Aug 2007 14\:53\:49 +0100")
Message-ID: <h87in5sgal.fsf@pepelac.englab.brq.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hey guys, the future of this patch is important for me. What do you think, has this patch any chances to be committed to upstream?

James Pearson <james-p@moving-picture.com> writes:
> H. Peter Anvin wrote:
> There isn't that much that is duplicated - and there are also bits of
> the /proc/PID/mem code that are not needed in this case, so I'm not
> really sure if it is worth doing.
>
> I did submit a patch a few months ago - see:
>
> <http://marc.info/?l=linux-kernel&m=117862109623007&w=2>

-- 
Anton Arapov, <aarapov@redhat.com>
