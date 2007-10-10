Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbXJJNlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbXJJNlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 09:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXJJNkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 09:40:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:46167 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbXJJNky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 09:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I9oFNzZ2lICwHHXIxskgwrleFsK9tQbWw3RVWHhxTduAPqoon23dfwK67nudeYA/GlpHlZZKMzFUPG+hblpC0KvCrC7bUnGOnuLZGFqvZepAWQ44ZiPoXCoR86IPS0bdtrYJWGj9ntjpOw5rTQ06vcuq+nhQOnPs/zhHzmJ/B88=
Message-ID: <7b69d1470710100640g230818ep243a58b256a78c02@mail.gmail.com>
Date: Wed, 10 Oct 2007 08:40:51 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: RFC: reviewer's statement of oversight
Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <10940.1191883390@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071008173706.GA12026@uranus.ravnborg.org>
	 <10940.1191883390@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/07, Jonathan Corbet <corbet@lwn.net> wrote:

Some minor rewording suggestions:

> + (b) Any problems, concerns, or questions relating to the patch have been
> +     communicated back to the submitter.  I am satisfied with how the
> +     submitter has responded to my comments.
---

Replace the last sentence with "I am satisfied with the submitter's
response to my comments." or "The submitter has responded to my
comments in a way that satisfied my concerns."

---
> +
> + (c) While there may (or may not) be things which could be improved with
> +     this submission, I believe that it is, at this time, (1) a worthwhile
> +     modification to the kernel, and (2) free of known issues which would
> +     argue against its inclusion.
---

I would suggest dropping the "(or may not)" as unnecessary, and
changing the "which would" to "that would".

---
> +
> + (d) While I have reviewed the patch and believe it to be sound, I can not
---

>From a legal standpoint, "I do not" might be preferable to "I cannot",
since it disclaims any intention to make such a statement, regardless
of qualification.

---
> +     (unless explicitly stated elsewhere) make any warranties or guarantees
> +     that it will achieve its stated purpose or function properly in any
> +     given situation.
> +
> + (e) I understand and agree that this project and the contribution are
> +     public and that a record of the contribution (including my Reviewed-by
> +     tag and any associated public communications) is maintained
> +     indefinitely and may be redistributed consistent with this project or
> +     the open source license(s) involved.
---

(e) seems over-careful, especially since you're applying it only to
the Review-by tag, while all the other tags would also have the same
concern.



-- 
scott preece
